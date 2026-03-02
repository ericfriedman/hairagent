import { Sparkle } from "./sparkle";

export function Hero() {
  return (
    <section className="relative min-h-[90vh] flex items-center overflow-hidden bg-white">
      {/* Decorative color blobs */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-ha-pink/40 rounded-full blur-3xl -translate-x-1/3 -translate-y-1/3" />
      <div className="absolute top-1/4 right-0 w-80 h-80 bg-ha-blue/30 rounded-full blur-3xl translate-x-1/3" />
      <div className="absolute bottom-0 left-1/3 w-72 h-72 bg-ha-yellow/30 rounded-full blur-3xl translate-y-1/3" />

      <div className="relative z-10 mx-auto max-w-7xl px-6 py-20 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
        {/* Left: Copy */}
        <div>
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight text-black leading-tight">
            Meet Your New
            <br />
            Hair BFF.
          </h1>
          <p className="mt-6 text-xl md:text-2xl text-black/60 max-w-lg leading-relaxed">
            Answer a few fun questions about your hair and get custom DIY
            recipes in seconds.
          </p>
          <div className="mt-10">
            <a
              href="#"
              className="inline-block bg-ha-coral text-white px-10 py-4 rounded-full text-lg font-semibold hover:opacity-90 transition-opacity shadow-lg shadow-ha-coral/30"
            >
              Coming Soon to the App Store
            </a>
          </div>
        </div>

        {/* Right: iPad Mockup - matches the actual app */}
        <div className="flex justify-center lg:justify-end">
          <div className="relative w-[340px] md:w-[400px] h-[480px] md:h-[560px] bg-white rounded-[2.5rem] shadow-2xl border border-gray-200 p-8 flex flex-col items-center justify-center">
            {/* Status bar dots */}
            <div className="absolute top-4 w-20 h-1.5 bg-gray-200 rounded-full" />

            {/* App content mimicking the welcome screen */}
            <h2 className="text-4xl md:text-5xl font-bold text-black mt-4">Hair Agent</h2>
            <p className="text-gray-400 mt-3 text-lg text-center">
              Your personal hair care advisor
            </p>

            {/* Spacer to push button down like the real app */}
            <div className="flex-1" />

            {/* Coral pill button matching the app exactly */}
            <div className="w-full max-w-[240px] bg-ha-coral text-white text-center py-4 rounded-full font-semibold text-lg shadow-lg shadow-ha-coral/25">
              Get Started
            </div>

            {/* Bottom home indicator */}
            <div className="mt-6 w-32 h-1 bg-gray-200 rounded-full" />
          </div>

          {/* Floating sparkles around the mockup */}
          <Sparkle className="absolute top-8 right-8 w-6 h-6 hidden lg:block" color="#FFB5C2" />
          <Sparkle className="absolute bottom-16 right-4 w-5 h-5 hidden lg:block" color="#ADD9F4" />
          <Sparkle className="absolute top-1/3 right-2 w-4 h-4 hidden lg:block" color="#FFF0B3" />
        </div>
      </div>
    </section>
  );
}
