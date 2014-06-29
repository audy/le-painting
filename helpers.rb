class Skellington < Sinatra::Base
  helpers do
    def logged_in?
      ! @user.nil?
    end

    def admin?
      @user.admin rescue false
    end

    def flash
      message = session[:flash]
      session[:flash] = nil
      message
    end

    def bad_user! message, args = {}
      redirect_to = args[:redirect_to] || '/'
      session[:flash] = message
      redirect redirect_to
    end

    def protect
      bad_user! 'Not logged in!' unless logged_in?
    end
  end
end
