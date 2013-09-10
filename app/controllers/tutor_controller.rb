# encoding: utf-8
class TutorController < ApplicationController
  include LtiTccFilters
  before_filter :check_permission

  def index
    user_name = MoodleUser.get_name(@user_id)

    # Problema no webservice
    render 'public/404.html' unless user_name

    group = TutorGroup.get_tutor_group(user_name)
    @group_name = TutorGroup.get_tutor_group_name(group)

    @tccs = Tcc.where(tutor_group: group).paginate(:page => params[:page], :per_page => 30) unless group.nil?
    @hubs = Tcc.hub_names
  end

  private

  def check_permission
    unless current_user.tutor?
      flash[:error] = 'Você não possui permissão para acessar esta página'
      redirect_user_to_start_page
    end
  end
end