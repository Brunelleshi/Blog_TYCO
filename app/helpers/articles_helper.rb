module ArticlesHelper
    def day_month_year(datetime)
        datetime.strftime('%e, %B, %Y') 
    end
end
