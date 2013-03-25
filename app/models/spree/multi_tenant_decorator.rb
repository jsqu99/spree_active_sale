module Spree
  [ActiveSale,ActiveSaleEvent].each do |model|
      model.send(:include, SpreeLandlord::TenantedModel)
    end
end




