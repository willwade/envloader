class Envloader < Formula
  desc "Minimal, standalone .env and .envrc loader with no dependencies"
  homepage "https://github.com/willwade/envloader"
  version "0.1.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/willwade/envloader/releases/download/v#{version}/envloader_Darwin_arm64.tar.gz"
    else
      url "https://github.com/willwade/envloader/releases/download/v#{version}/envloader_Darwin_x86_64.tar.gz"
    end
  end

  def install
    bin.install "envloader"
  end

  test do
    system "#{bin}/envloader", "--version"
  end
end