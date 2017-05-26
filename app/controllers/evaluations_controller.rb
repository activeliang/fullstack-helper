class EvaluationsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    @evaluation = Evaluation.new(evaluation_params)
    @evaluation.user = current_user
    @evaluation.product = @product
    if @evaluation.save
      redirect_to :back, notice: "新增成功！"
    else
      redirect_to :back, alert: "出错！新增失败！"
    end
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:grade, :description)
  end


end
