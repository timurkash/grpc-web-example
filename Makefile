proto-by-docker:
	@echo "--> Generating gRPC clients"
	@docker run \
	  -v `pwd`/api:/api \
	  -v `pwd`/time/goclient:/goclient \
	  -v `pwd`/frontend/src/jsclient:/jsclient \
	  jfbrandhorst/grpc-web-generators \
	  protoc \
	  -I /api \
	  --go_out=plugins=grpc,paths=source_relative:/goclient \
	  --js_out=import_style=commonjs:/jsclient \
	  --grpc-web_out=import_style=commonjs,mode=grpcwebtext:/jsclient \
	 /api/time/v1/time_service.proto

proto:
	@echo "--> Generating gRPC clients"
	@protoc \
		-I api \
		--go_out=paths=source_relative:time/goclient \
		--go-grpc_out=paths=source_relative:time/goclient \
		--js_out=import_style=commonjs:frontend/src/jsclient \
		--grpc-web_out=import_style=commonjs,mode=grpcwebtext:frontend/src/jsclient \
		api/time/v1/time_service.proto

run-frontend:
	@echo "--> Starting frontend"
	cd ./frontend
	npm i
	npm run serve

run-servers:
	@echo "--> Starting servers"
	@docker-compose up -d

curl:
	@echo "--> curl HTTP/1.1 http://localhost:8080/time.v1.TimeService/GetCurrentTime"
	@bash ./1.sh > 1
	@cat 1 | base64 --decode
