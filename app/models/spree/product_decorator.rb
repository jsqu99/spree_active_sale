Spree::Product.class_eval do
  has_many :active_sale_events, :as => :eventable

  def find_live_taxons
    Spree::ActiveSaleEvent.live_active.where(:eventable_type => "Spree::Taxon", :eventable_id => taxons_plus_children(self.taxons))
  end

  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil? || !self.find_live_taxons.blank?
  end

  private
    def taxons_plus_children(taxons)
      ids = taxons.inject([]) { |ids, taxon|
        puts "taxon: #{taxon}"
        puts "ids: #{ids}"
  
        ids << [taxon.id]

        taxons = taxon.children

        if taxons.present?
          ids << taxons_plus_children(taxons)
        end
        ids.flatten
      }
    end
end
