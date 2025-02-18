class Envloader < Formula
  desc "Minimal, standalone .env and .envrc loader with no dependencies"
  homepage "https://github.com/willwade/envloader"
  version "0.1.3"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/willwade/envloader/releases/download/v0.1.1/envloader_Darwin_arm64.tar.gz"
      sha256 "853854d90a42cfebb0f26ffdcf3ed6ec3b86bb65415c5b1a39f1f6705e5c7bc3"
    else
      url "https://github.com/willwade/envloader/releases/download/v0.1.1/envloader_Darwin_x86_64.tar.gz"
      sha256 "af282500927b5e9ff443e020f00a301e5a02ff3aecc3cf5a787acee3231cfc79"
    end
  else
    url "https://github.com/willwade/envloader/releases/download/v0.1.1/envloader_Linux_x86_64.tar.gz"
    sha256 "00c8d44480f55f5da2fb5fa2d7967ec5d10bb51d78bbc0b2c3b5e47533ec24fb"
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