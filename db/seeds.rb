Article.delete_all 

user = User.first
text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris felis augue, tincidunt vel fermentum ut, scelerisque vitae leo. Aliquam venenatis bibendum risus, sit amet consequat lorem tincidunt sed. Suspendisse blandit turpis vitae lectus ultricies, sed molestie felis dignissim. Quisque quis dignissim lorem, sit amet sodales nibh. Aliquam aliquam tempus pretium. Fusce hendrerit enim nunc, id consequat magna semper nec. Praesent eu quam consequat, ultrices leo vel, molestie lorem. Nunc tincidunt facilisis velit, at imperdiet leo aliquam at."

p 'Iniciando ...'
Category.all.each do |category|
    30.times do
        Article.create!(
            title: "Article #{rand(10000)}",
            body: text,
            category_id: category.id,
            user_id: user.id,
            created_at: rand(365).days.ago
        )
    end
end
p 'Terminou'