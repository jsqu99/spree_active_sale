require 'spec_helper'

describe Spree::HomeController do
  let(:ability_user) { stub_model(Spree::LegacyUser) }

  before do
    controller.stub(:authorize! => true)
    controller.stub(:try_spree_current_user => ability_user)

    Spree::Tenant.all.map(&:destroy)
    @orange_tenant = Spree::Tenant.create!(name: 'orange', shortname: 'orange', domain: 'orange.domain')
  end

  let(:product) { create(:product) }

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSaleEvent. As you add validations to Spree::ActiveSaleEvent, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      "name"=>"Dummy Event", 
      "description"=>"Dummy event description data", 
      "start_date"=> Time.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "eventable_type"=> product.class.to_s, 
      "eventable_name"=> product.name, 
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0"
    }
  end

  def active_sale_valid_attributes
    { "name" => "Dummy Sale" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::ActiveSaleEventsController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  before do
    controller.stub :current_user => FactoryGirl.create(:admin_user)
    # @active_sales = FactoryGirl.create_list(:active_sales, 10)
    # @active_sales.each{ |active_sale| FactoryGirl.create_list(:active_sale_events, 10) }
    @active_sale = Spree::ActiveSale.create! active_sale_valid_attributes
    @active_sale.active_sale_events.create! valid_attributes
  end

  describe "GET index" do
    it "assigns all active_sale_event_events as @active_sale_event_events" do
      Spree::Tenant.set_current_tenant(@orange_tenant) 
      request.stub(:domain => 'orange.domain')          

      spree_get :index, {}, valid_session
      @active_sale.active_sale_events.each{ |event| event.live_and_active?.should be_true }
      assigns(:sale_events).should eq(Spree::ActiveSaleEvent.live_active.to_a)
    end
  end

end
