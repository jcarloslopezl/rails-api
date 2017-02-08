class Order < ApplicationRecord
	before_validation :set_total!
	
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :total, presence: true,
                      numericality: { greater_than_or_equal_to: 0 }

  validates :user_id, presence: true
  validates_with EnoughProductsValidator

  def set_total!
    self.total = 0
    placements.each do |placement|
      self.total += placement.product.price * placement.quantity
    end
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      id, quantity = product_id_and_quantity # [1,5]

      self.placements.build(product_id: id, quantity: quantity)
    end
  end

  describe "#valid?" do
    before do
      product_1 = FactoryGirl.create :product, price: 100, quantity: 5
      product_2 = FactoryGirl.create :product, price: 85, quantity: 10


      placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
      placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15

      @order = FactoryGirl.build :order

      @order.placements << placement_1
      @order.placements << placement_2
    end

    it "becomes invalid due to insufficient products" do
      expect(@order).to_not be_valid
    end
  end

end
