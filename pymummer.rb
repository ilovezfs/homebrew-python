class Pymummer < Formula
  desc "Python3 wrapper for running MUMmer and parsing the output"
  homepage "https://github.com/sanger-pathogens/pymummer"
  url "https://github.com/sanger-pathogens/pymummer/archive/v0.10.0.tar.gz"
  sha256 "381927a3dfee34727da173bfc747b34a9ddecb1647c2d36c3df4ceb297f85309"
  head "https://github.com/sanger-pathogens/pymummer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f56b0078fbf1ce577128883d9c61d08261694c4da2f3eb3eca823f1146945bd1" => :sierra
    sha256 "f56b0078fbf1ce577128883d9c61d08261694c4da2f3eb3eca823f1146945bd1" => :el_capitan
    sha256 "f56b0078fbf1ce577128883d9c61d08261694c4da2f3eb3eca823f1146945bd1" => :yosemite
  end

  # tag "bioinformatics"

  depends_on :python3
  depends_on "homebrew/science/mummer"

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/0e/5d/8b39442b62c43da835c89f4c244d037bc7fcd8b47b0c0fff6e8d9097a035/pyfastaq-3.14.0.tar.gz"
    sha256 "54dc8cc8b3d24111f6939cf563833b8e9e78777b9cf7b82ca8ddec04aa1c05f2"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resource("pyfastaq").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      pyfastaq_path = libexec/"vendor/lib/python#{version}/site-packages"
      dest_path = lib/"python#{version}/site-packages"
      mkdir_p dest_path
      (dest_path/"homebrew-pymummer-pyfastaq.pth").write "#{pyfastaq_path}\n"
    end

    ENV.prepend_create_path "PYTHONPATH", prefix/"lib/python#{version}/site-packages"
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "from pymummer import coords_file, alignment, nucmer; nucmer.Runner('ref', 'qry', 'outfile')"
  end
end
