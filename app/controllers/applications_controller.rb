class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: [:edit, :update, :destroy]

  def new
  end

  def create
    @application = Doorkeeper::Application.new(application_params[:doorkeeper_application])
    @application.owner = current_user if Doorkeeper.configuration.confirm_application_owner?

    if @application.save
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
      redirect_to edit_user_registration_path
    else
      flash[:alert] = "Failed to create application: #{@application.errors.full_messages.to_sentence}."
      redirect_to new_application_path
    end
  end

  def edit
  end

  def update
    if cannot?(:update, @application)
      render :forbidden, status: 403
      return
    end

    if @application.update(edit_application_params[:doorkeeper_application])
      flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications update])
    else
      flash[:alert] = "Failed to update #{@application.name}: #{@application.errors.full_messages.to_sentence}"
    end
    redirect_to edit_user_registration_path
  end

  def destroy
    if cannot?(:destroy, @application)
      render :forbidden, status: 403
      return
    end

    @application.destroy
    flash[:notice] = "#{@application.name} has been deleted."
    redirect_to edit_user_registration_path
  end

  private

  def set_application
    @application = Doorkeeper::Application.find(params[:application])
  end

  def application_params
    params.permit(doorkeeper_application: [:name, :redirect_uri])
  end

  def edit_application_params
    params.permit(doorkeeper_application: [:redirect_uri])
  end
end
