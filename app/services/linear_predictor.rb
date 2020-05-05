class LinearPredictor
  def initialize(x_data, y_data)
    x = Matrix.columns([Array.new(x_data.length, 1), x_data])
    y = Matrix.column_vector(y_data)
    @b = (x.transpose * x).inverse * x.transpose * y
  end

  def coefficients
    @b.column(0).to_a
  end

  def predict_for(x)
    y = Matrix.row_vector([1, x]) * @b
    y[0, 0]
  end

  def inverse_predict_for(y)
    x = (y - @b[0, 0]) / @b[1, 0]
  end
end
