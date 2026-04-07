class Mws < Formula
  desc "Multi-task workspace manager for multi-repo projects"
  homepage "https://github.com/paulo20223/mws"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/paulo20223/mws/releases/download/v#{version}/mws-darwin-arm64"
      sha256 "efbd7978d30ced75d83bbffeac26b899606817b0d44f7d9ebe4af118fc068b1b"
    else
      url "https://github.com/paulo20223/mws/releases/download/v#{version}/mws-darwin-amd64"
      sha256 "2d737753f197921015764b12f1f5f84a56caa64886634f1c3d7e3e51dcfa7cb9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/paulo20223/mws/releases/download/v#{version}/mws-linux-arm64"
      sha256 "825a08d1d3ae95201ffadf7e75e1e851c705df1468e578cc1af0e0178b1657c5"
    else
      url "https://github.com/paulo20223/mws/releases/download/v#{version}/mws-linux-amd64"
      sha256 "977dc91e89ff56c952082fefae66d7263eeccf00579e8e0e75e51d6479695e10"
    end
  end

  def install
    binary = Dir["mws-*"].first || "mws"
    bin.install binary => "mws"
  end

  def post_install
    marker = "# >>> mws initialize >>>"
    shell = ENV["SHELL"] || "/bin/zsh"
    rc = if shell.include?("zsh")
           File.expand_path("~/.zshrc")
         elsif shell.include?("bash")
           File.expand_path("~/.bashrc")
         else
           File.exist?(File.expand_path("~/.zshrc")) ? File.expand_path("~/.zshrc") : File.expand_path("~/.bashrc")
         end

    return if File.exist?(rc) && File.read(rc).include?(marker)

    File.open(rc, "a") do |f|
      f.puts ""
      f.puts marker
      f.puts 'eval "$(mws shell-init)"'
      f.puts "# <<< mws initialize <<<"
    end
    ohai "Shell integration added to #{rc}"
  end

  def caveats
    <<~EOS
      Shell integration (mcd, prompt) has been automatically added to your shell rc file.
      Restart your shell or run:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "Multi-task workspace manager", shell_output("#{bin}/mws --help")
  end
end
