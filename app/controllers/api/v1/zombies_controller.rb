class Api::V1::ZombiesController < ApplicationController
  before_action :set_zombie, only: [:show, :update, :destroy]
  deserializable_resource :zombie, class: DeserializableZombie, only: %i[create update]

  def index
    @zombies = Zombie.preload(:armors, :weapons).all
    json_response(@zombies)
  end

  def create
    @zombie = Zombie.create!(zombie_params)
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

  private

  def set_zombie
    @zombie = Zombie.find(params[:id])
  end

  def zombie_params
    params.require(:zombie).permit(:name, :hit_points, :brains_eaten, :speed, :turn_date,
      weapon_ids: [], armor_ids: [],
      weapons_attributes: %i[name attack_points durability price],
      armors_attributes: %i[name defense_points durability price])
  end
end
