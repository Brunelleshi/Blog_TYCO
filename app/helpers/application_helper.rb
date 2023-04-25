module ApplicationHelper
    def render_if(condition, template, record)
       render template, record if condition 
    end

    def day_month_year(value)
        l(value, format: '%B %e, %Y').capitalize 
    end

    def month_year(value)
        l(value.to_datetime, format: '%B %Y').capitalize 
    end
end
