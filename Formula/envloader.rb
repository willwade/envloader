class Envloader < Formula
  desc "Minimal, standalone .env and .envrc loader with no dependencies"
  homepage "https://github.com/willwade/envloader"
  version "0.1.6"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/willwade/envloader/releases/download/v0.1.6/envloader_Darwin_arm64.tar.gz"
      sha256 "a8bef03a3003bd1d7d3fdf587f153a0ce6eac048752bd6ed0b32398043ffeba2"
    else
      url "https://github.com/willwade/envloader/releases/download/v0.1.6/envloader_Darwin_x86_64.tar.gz"
      sha256 "4bd71bd8bf2fa4e89170a9c80bf14bd02edaaaa8d969b59ad12d3c383cdedae6"
    end
  else
    url "https://github.com/willwade/envloader/releases/download/v0.1.6/envloader_Linux_x86_64.tar.gz"
    sha256 "9e07b942e552eb0df786a3b5b842ea035c6bbf7eed01d47df047c70e3d9d7b88"
  end

  def install
    # Install the main binary
    bin.install "envloader"
    
    # Install Unix shell scripts only
    bin.install "envloader.sh"
    bin.install "envload"
  end

  test do
    system "#{bin}/envloader", "--version"
  end
end