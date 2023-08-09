for file in test/test_*.rb
do
  echo "require_relative '$file'"
done | ruby
