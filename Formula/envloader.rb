class Envloader < Formula
  desc "Minimal, standalone .env and .envrc loader with no dependencies"
  homepage "https://github.com/willwade/envloader"
  version "0.1.5"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/willwade/envloader/releases/download/v0.1.5/envloader_Darwin_arm64.tar.gz"
      sha256 "ba6499f6c860d4b2f65ffb9cc781f6af122a6039c0c31bac9049c0180c782994"
    else
      url "https://github.com/willwade/envloader/releases/download/v0.1.5/envloader_Darwin_x86_64.tar.gz"
      sha256 "0354e844d46f3fecbb2a7afd1ec26535f9f8265b17586f0c60cbd28ad719a17b"
    end
  else
    url "https://github.com/willwade/envloader/releases/download/v0.1.5/envloader_Linux_x86_64.tar.gz"
    sha256 "48d92b88949497af984982bb938055bdbff8ddf78a0e4e9fb5b670b1c1982e95"
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