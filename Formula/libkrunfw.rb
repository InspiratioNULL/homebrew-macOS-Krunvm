class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/slp/libkrunfw"
  url "https://github.com/containers/libkrunfw/releases/download/v3.11.0/v3.11.0-with_macos_prebuilts.tar.gz"
  sha256 "5dc76c2bc2f93703207a548c844d98298c5a0229ffde9ffe1ab9631866692b96"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]



  # libkrun, our only consumer, only supports Hypervisor.framework on arm64
  depends_on arch: :arm64

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int krunfw_get_version();
      int main()
      {
         int v = krunfw_get_version();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrunfw", "-o", "test"
    system "./test"
  end
end
