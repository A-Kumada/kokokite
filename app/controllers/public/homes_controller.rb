class Public::HomesController < ApplicationController

  def top
    @categories = Category.all
    @posts = Post.where(status:"public").all.order(created_at: :desc).limit(5)
    unless
      @posts.statuses == "private"
    end
    @post_pvs = Post.where(status: "public").sort {|a,b| b.impressions.size <=> a.impressions.size}
#    @post_pvs = Post.select('posts.*', 'count(impressions.id) as impressions_count').left_joins(:impressions).where(status: "public").group('posts.id').order('impressions_count asc').limit(5)
  end

  def about
  end

end
