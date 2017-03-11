class HalsController < ApplicationController
  before_action :set_hal, only: [:update]

  def update
    respond_to do |format|
      if @hal.update(hal_params)
        format.html { redirect_to listings_url }
        # format.json { render :show, status: :ok, location: @hal }
      else
        format.html { render :edit }
        # format.json { render json: @hal.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hal
      @hal = Hal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hal_params
      params.require(:hal).permit(:on)
    end
end
