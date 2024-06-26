# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController

  include Devise::Controllers::Helpers
  include Devise::Controllers::urlHelpers 
  
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    super do |user|
      if user.errors.empty?
        userMailer.with(user:user).reset_password_email.deliver_now
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
