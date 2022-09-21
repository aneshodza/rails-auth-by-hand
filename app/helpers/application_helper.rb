module ApplicationHelper
  def parse_session_token
    token = cookies[:session_token]
    return { id: token.split(';')[0], key: token.split(';')[1] } if token

    false
  end

  def logged?
    return false unless parse_session_token

    session_token = ManualSessionToken.find_by(user_id: parse_session_token[:id])
    return false unless session_token

    encrypt = Digest::SHA256.hexdigest(cookies[:session_token] + session_token.salt + ManualSessionToken::PEPPER)
    if encrypt == session_token.key
      true
    else
      send_to_login
      false
    end
  end

  def send_to_login
    flash[:error] = 'You must be logged in to access this page'
    redirect_to '/login'
  end
end
