require 'rake'
require 'io/console'

REGISTRY = "ghcr.io"
OWNER = ENV['GITHUB_USER'] || `git config --get user.name`.strip.downcase
REPO = 'ruby-devel-notebook'
IMAGE_NAME = "#{OWNER}/#{REPO}"
PLATFORMS = "linux/amd64,linux/arm64"

def git_remote_url
  `git remote get-url origin`.strip
end

def github_repo
  if git_remote_url =~ /github\.com[:|\/](.*?\/.*?)(?:\.git)?$/
    $1
  else
    "#{OWNER}/#{REPO}"
  end
end

namespace :docker do
  desc "Setup docker buildx"
  task :setup do
    sh "docker buildx create --use --name multiarch-builder || true"
  end

  desc "Build multi-architecture image"
  task build: :setup do
    version = ENV['VERSION'] || 'latest'
    tag = "#{REGISTRY}/#{github_repo}:#{version}"

    sh "docker buildx build \
      --platform #{PLATFORMS} \
      --tag #{tag} \
      --label org.opencontainers.image.source=https://github.com/#{github_repo} \
      --label org.opencontainers.image.description='Ruby Development Notebook for Jupyter' \
      --label org.opencontainers.image.licenses=MIT \
      --cache-from type=registry,ref=#{tag} \
      --cache-to type=inline \
      --push \
      ."
  end

  desc "Login to GitHub Container Registry"
  task :login do
    print "GitHub Personal Access Token: "
    token = STDIN.noecho(&:gets).chomp
    puts

    sh "echo #{token} | docker login #{REGISTRY} -u #{OWNER} --password-stdin"
  end

  desc "Clean up buildx builder"
  task :clean do
    sh "docker buildx rm multiarch-builder || true"
  end

  desc "Build and push all versions"
  task release: [:login, :build, :clean]
end

desc "Build and push multi-architecture image (shortcut for docker:release)"
task release: "docker:release"
