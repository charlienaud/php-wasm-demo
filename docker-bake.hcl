target "default" {
	output = ["type=local,dest=./public/dist"]
	tags = ["php-wasm"]
	args = {
		PHP_BRANCH = "PHP-8.3.10"
	}
}
