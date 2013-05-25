module ApplicationHelper
    def sortable(column, title = nil)
        css_class = column == sort_column ? "current #{sort_direction}" : nil
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        link_to title, params.merge(:sort => column, :direction => direction), { :class => css_class }
    end

    def paginate(scope)
        content_tag :ul do
            Candidate.new.total_pages.each do |page|
                content_tag :li do
                    link_to page.to_s, { :controller => "candidates", :action => "index", :page => page }
                end
            end
        end
    end
end
