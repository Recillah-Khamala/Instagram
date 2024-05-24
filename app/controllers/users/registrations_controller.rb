# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :set_minimum_password_length, only: [:new, :edit]
  before_action :set_devise_mapping
  before_action :set_devise_mapping, only: [:new, :create]

  respond_to :json


  include Devise::Controllers::Helpers

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    Rails.logger.debug "Raw request body: #{request.raw_post}"
    Rails.logger.debug "Received params: #{params.inspect}"
    build_resource(sign_up_params)
  
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render json: { success: true, user: resource, message: I18n.t('devise.registrations.signed_up') }, status: :created
      else
        expire_data_after_sign_in!
        render json: { success: true, user: resource, message: I18n.t("devise.registrations.signed_up_but_#{resource.inactive_message}") }, status: :created
      end
    else
      Rails.logger.info "User parameters: #{sign_up_params.inspect}"
      Rails.logger.info "Validation errors: #{resource.errors.full_messages.inspect}"
      clean_up_passwords resource
      set_minimum_password_length
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # Sets minimum password length to show to user
  def set_minimum_password_length
    Rails.logger.info "Devise mapping: #{devise_mapping.inspect}"
    if devise_mapping&.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end

  # Explicitly set the Devise mapping
  def set_devise_mapping
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def resource_name
    :user
  end
end
