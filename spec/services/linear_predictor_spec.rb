RSpec.describe LinearPredictor do
  it 'calculates coefficients' do
    x = [4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0]
    y = [33, 42, 45, 51, 53, 61, 62]

    coefficients = LinearPredictor.new(x, y).coefficients
    expect(coefficients[0]).to be_within(0.1).of(-2.67)
    expect(coefficients[1]).to be_within(0.1).of(9.51)
  end

  it 'predicts' do
    x = [4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0]
    y = [33, 42, 45, 51, 53, 61, 62]

    prediction = LinearPredictor.new(x, y).predict_for(5.0)
    expect(prediction).to be_within(0.2).of(45)
  end
end