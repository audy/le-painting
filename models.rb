require 'bcrypt'

class User
  include DataMapper::Resource
  include BCrypt

  attr_accessor :password

  property :created_at, DateTime

  property :id,    Serial
  property :email, String
  property :name,  String
  property :admin, Boolean, default: false
  property :crypted_password, String, :length => 70

  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_format_of        :email,    :with => :email_address
  validates_presence_of      :password, :if => :password_required
  validates_presence_of      :name

  has n, :posts

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:conditions => { :email => email })
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    Password.new(crypted_password) == password
  end

  # Callbacks
  before :save, :encrypt_password

  private

  def password_required
    !(crypted_password.nil? || password.nil?)
  end

  def encrypt_password
    self.crypted_password = Password.create(password)
  end
end

class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    'uploads'
  end
end

class Forkenship
  include DataMapper::Resource

  belongs_to :source, 'Post', key: true
  belongs_to :target, 'Post', key: true
end

class Post
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime
  property :title,      String
  property :hidden, Boolean, default: false

  mount_uploader :file, ImageUploader
  
  belongs_to :user

  before :save, :strip_title

  #
  # forking stuff
  #
  
  has n, :forkenships, child_key: [ :source_id ]
  has n, :forks, self, through: :forkenships, via: :target

  private

  def strip_title
    self.title.strip!
  end
end
