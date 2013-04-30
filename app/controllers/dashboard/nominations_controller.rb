class Dashboard::NominationsController < ApplicationController
    before_filter :autorization_check

    layout "dashboard"

    def index
        @title = I18n.t("shared.nominations.common.title")
        @nominations = Nomination.order("name").all
        @nomination = Nomination.new
    end

    def create
        @nomination = Nomination.create!(params[:nomination])
        @nominations_n = Nomination.order("name").all
        respond_to do |format|
            format.js
            format.html
        end
    end

    def get_to_edit
        val = params[:nomination_id]
        render :partial => "edit_this_nomination", :locals => { :this_nomination => Nomination.find(val) }
    end

    def update
        @nomination = Nomination.find(params[:id]).update_attributes(params[:nomination])
        @nominations_n = Nomination.order("name").all
        respond_to do |format|
            format.js
        end
    end

    def destroy
        @nomination = Nomination.find(params[:id])
        begin
            @nomination.destroy
        rescue ActiveRecord::DeleteRestrictionError => e
            @nomination.errors.add( :base, I18n.t("errors.restrict_nom_cand") )
        end
        @val = params[:id]
    end
end
