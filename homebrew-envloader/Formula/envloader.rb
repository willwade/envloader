class Envloader < Formula
  desc "Minimal, standalone .env and .envrc loader with no dependencies"
  homepage "https://github.com/willwade/envloader"
  version "0.1.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/willwade/envloader/releases/download/v0.1.0/envloader_Darwin_arm64.tar.gz"
      sha256 "" # Add SHA after release
    else
      url "https://github.com/willwade/envloader/releases/download/v0.1.0/envloader_Darwin_x86_64.tar.gz"
      sha256 "" # Add SHA after release
    end
  else
    url "https://github.com/willwade/envloader/releases/download/v0.1.0/envloader_Linux_x86_64.tar.gz"
    sha256 "" # Add SHA after release
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