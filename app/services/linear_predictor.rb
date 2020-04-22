class LinearPredictor
  def initialize(x_data, y_data)
    x_data = x_data.map { |x| [x] }

    @predictor = RubyLinearRegression.new
    @predictor.load_training_data(x_data, y_data)
    @predictor.train_normal_equation
  end

  def predict_for(value)
    @predictor.predict([value])
  end
end