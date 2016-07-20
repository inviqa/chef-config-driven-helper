directory "/docroot" do
end

file "/docroot/index.php" do
  content "<?php echo 'hello world';"
end

file "/docroot/proxy-header-hide.php" do
  content "<?php echo getenv('HTTP_PROXY');"
end
