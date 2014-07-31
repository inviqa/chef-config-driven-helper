directory "/docroot" do
  owner "nginx"
  group "nginx"
end

file "/docroot/index.php" do
  owner "nginx"
  group "nginx"
  content "<?php echo 'hello world'; ?>"
end
