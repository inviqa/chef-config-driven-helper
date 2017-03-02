directory "/docroot"

file "/docroot/index.php" do
  content "<?php echo 'hello world';"
end

file "/docroot/proxy-header-hide.php" do
  content "<?php echo getenv('HTTP_PROXY');"
end

directory "/docroot/media"

file "/docroot/media/test.php" do
  content "<?php echo 'hello world';"
end

directory "/docroot/secret"

file "/docroot/secret/test.php" do
  content "<?php echo 'hello world';"
end
