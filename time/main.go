package main

import (
	"context"
	"fmt"
	pb "github.com/timurkash/grpc-web-example/time/goclient/time/v1"
	"google.golang.org/grpc"
	"log"
	"net"
	"os"
	"time"
)

const listenAddress = ":9090"

var test = os.Getenv("TEST")

type timeService struct {
	pb.UnimplementedTimeServiceServer
}

func (t *timeService) GetCurrentTime(_ context.Context, req *pb.GetCurrentTimeRequest) (*pb.GetCurrentTimeResponse, error) {
	log.Println("Got time request")
	return &pb.GetCurrentTimeResponse{
		CurrentTime: fmt.Sprintf("%s: %s: %s", test, req.Dump, time.Now().String()),
	}, nil
}

func main() {
	log.Println("test")
	log.Println(test)
	log.Println("test")
	log.Printf("Time service starting on %s", listenAddress)
	listener, err := net.Listen("tcp", listenAddress)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterTimeServiceServer(s, &timeService{})

	if err := s.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
