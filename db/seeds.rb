# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Comfy::Cms::Page.count > 0
  p "**************************************************"
  p "Adding Cms:Page content"
  p "**************************************************"
  if Comfy::Cms::Page.find_by_full_path("/index-block-2").blank?
    p "Add /index-block-2"
    Comfy::Cms::Page.create(site_id: 1, layout_id: 2, parent_id: 1, target_page_id: nil, label: "Index Block 2", slug: "index-block-2", full_path: "/index-block-2", content_cache: "<br>\r\nNot all appraisal providers are equal.  ValueThisNow offers superior turnaround times — often under 3 hours.  \r\nWe offer reports that are suitable for property insurance related matters or matters concerning equitable property \r\ndistribution. Our world-class appraiser community can provide amazing facts and history about your antiques \r\nand collectibles saving you time and money before you buy or sell.  Our appraisal reports start at $19.95, are \r\nUSPAP compliant and come with a 100% money back guarantee if your not satisfied. \r\nWhat are you waiting for? <a href=\"/users/sign_in\">Let's find out what your treasure is worth.</a>", position: 47, children_count: 0, is_published: true, is_shared: false)
  end

  if Comfy::Cms::Page.find_by_full_path("/index-block-1").blank?
    p "Add /index-block-1"
    Comfy::Cms::Page.create( site_id: 1, layout_id: 2, parent_id: 1, target_page_id: nil, label: "Index Block 1", slug: "index-block-1", full_path: "/index-block-1", content_cache: "<br>\r\nYou can learn a lot from an appraisal. For example, if you have an item to sell, an appraisal will help you get the best price. Insurance companies may require appraisals for property insurance. If you are moving, it's a good idea to get items appraised in case they are damaged during the move and you need to file a damage claim.\r\n<br><br>\r\nAppraisals are also very valuable for life events such as wills, inheritence and divorce. In addition to learning about the market value of your item, you can also learn about its history. Each piece has a story to tell and our expert appraisers can reveal that story to you. They can also help you find groups and other people that share your interest in the item. <a href=\"#\"></a><a href=\"/users/sign_in\">Learn about your item with an online appraisal.</a>\r\n<br><br><br><br><br><br>", position: 48, children_count: 0, is_published: true, is_shared: false)
  end

  if Comfy::Cms::Page.find_by_full_path("/tips-for-damage-claims-appraisals").blank?
    p "Add /tips-for-damage-claims-appraisals"
    Comfy::Cms::Page.create(site_id: 1, layout_id: 1, parent_id: 1, target_page_id: nil, label: "Tips for Damage Claims Appraisals", slug: "tips-for-damage-claims-appraisals", full_path: "/tips-for-damage-claims-appraisals", content_cache: "<div class=\"row\">\r\n\t<div class=\"col-md-9 col-md-offset-1\">\r\n\t\t<div class=\"big-title\">\r\n\t\t\t<h3>Tips for Damage Claims Appraisals</h3>\r\n\t\t</div>\r\n\t\t<style>\r\n  ul {padding-left: 30px;}\r\n</style>\r\n<p>\r\n  Here are some tips which will be helpful regarding appraisal requests being submitted for damage claims purposes. Following these tips will facilitate an expeditious reply to your appraisal request.\r\n</p>\r\n<ul>\r\n  <li>\r\n    Describe the item carefully including the location of pre-existing damages and old repairs. Unless noted, we will assume there was no pre-existing damages or old repairs. For appliances, electronics and machinery please provide make and model number.<br>\r\n    <br>\r\n  </li>\r\n  <li>\r\n    Explain in the Description that this is a damage claims appraisal and that you are looking for opinions of value as of just prior to the claimed damages having occurred, i.e., pre-incident. If you are seeking a different type of value, please explain; otherwise we will assume you want to know what the property is worth just prior to it becoming damaged.<br>\r\n    <br>\r\n  </li>\r\n  <li>\r\n    Provide good images. Images should be plentiful and in focus. Be sure to include an image showing the entire object. In addition, provide images of the claimed damages as well as pre-existing damages or old repairs.<br>\r\n    <br>\r\n  </li>\r\n  <li>\r\n    Was the item a part of a pair, set, service or suite? If so, in addition to the damaged part, provide a description and images of the entire pair, set, service or suite.\r\n  </li>\r\n</ul>\t\r\n\t</div>\r\n</div>", position: 49, children_count: 0, is_published: true, is_shared: false)
  end

  if Comfy::Cms::Page.find_by_full_path("/appraisers-knowledge-base").blank?
    p "Add /appraisers-knowledge-base"
    Comfy::Cms::Page.create(site_id: 1, layout_id: 1, parent_id: 1, target_page_id: nil, label: "Appraisers' Knowledge Base", slug: "appraisers-knowledge-base", full_path: "/appraisers-knowledge-base", content_cache: "", position: 50, children_count: 0, is_published: true, is_shared: false)
  end
end
