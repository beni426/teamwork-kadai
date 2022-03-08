class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end
  def update
    @agenda = Agenda.find(params[:id])
    @agenda.update(agenda_params)
    redirect_to dashboard_url
  end
  def destroy
    @agenda = Agenda.find(params[:id])
     if current_user.id == @agenda.user.id || current_user.id == @team.owner.id
       @keep_team_id =  @agenda.team_id
       @user_id_array = Assign.where(team_id: @keep_team_id).pluck(:user_id)
       @email_list =  @user_id_array.map do |user_id|
         User.where(id: user_id).pluck(:email)[0]
        end
        @agenda.destroy
         AssignMailer.delete_agenda(@email_list).deliver
        redirect_to dashboard_url, notice: "#{@agenda.title}を削除しました。"
      end
      
  
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
