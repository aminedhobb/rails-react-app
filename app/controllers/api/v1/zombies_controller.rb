class Api::V1::ZombiesController < ApplicationController
  before_action :set_zombie, only: %i[show update destroy]
  skip_before_action :authenticate_user!, only: [:index, :show, :user]
  deserializable_resource :zombie, class: DeserializableZombie, only: %i[create update]

  def index
    @zombies = if params[:query].present?
                 Zombie.search(params[:query], match: :word_start).results
               else
                 Zombie.preload(:armors, :weapons).all
               end
    json_response(@zombies)
  end

  def create
    @zombie = Zombie.new(zombie_params)
    @zombie.user = current_user
    @zombie.save!
    json_response(@zombie, 201)
  end

  def show
    json_response(@zombie)
  end

  def update
    @zombie.update!(zombie_params)
    head :no_content
  end

  def destroy
    @zombie.destroy
    head :no_content
  end

  def user
    render json: { user_id: current_user&.id }
  end

  private

  def set_zombie
    @zombie = Zombie.find(params[:id])
  end

  def zombie_params
    params.require(:zombie).permit(:name, :hit_points, :brains_eaten, :speed,
      :turn_date, :user_id,
      weapon_ids: [], armor_ids: [],
      weapons_attributes: %i[name attack_points durability price],
      armors_attributes: %i[name defense_points durability price])
  end
end
