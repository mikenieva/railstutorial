module SessionsHelper
	def sign_in(user)
		# Primero, creamos el nuevo token
		remember_token = User.new_remember_token
		# Colocamos el token sin encriptar en los cookies del navegador
		cookies.permanent[:remember_token] = remember_token
		# Salvamos el token encriptado a la base de datos
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		# Establecemos al usuario actual con el usuario que se generó
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		# Cambiamos el token dle usuario en la Base de Datos
		current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
		# Usamos el método DELETE sobre las cookies para quitar el token de la sesión
		cookies.delete(:remember_token)
		# Establecemos el usuario recurrente a nil
		self.current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

end
