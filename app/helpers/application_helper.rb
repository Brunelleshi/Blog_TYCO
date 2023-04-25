module ApplicationHelper
    def render_if(condition, template, record)
       render template, record if condition 
    end

    def day_month_year(datetime)
        datetime.strftime('%e, %B, %Y') 
    end
end
