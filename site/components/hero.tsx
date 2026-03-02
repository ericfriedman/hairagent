export function Hero() {
  return (
    <section className="relative min-h-[90vh] flex items-center overflow-hidden">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-ha-pink via-ha-coral/30 to-ha-blue/40" />

      <div className="relative z-10 mx-auto max-w-7xl px-6 py-20 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
        {/* Left: Copy */}
        <div>
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight text-black">
            Meet Your New
            <br />
            Hair BFF.
          </h1>
          <p className="mt-6 text-xl md:text-2xl text-black/70 max-w-lg">
            Answer a few fun questions about your hair and get custom DIY
            recipes in seconds.
          </p>
          <div className="mt-10">
            <a
              href="#"
              className="inline-block bg-black text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-black/80 transition-colors"
            >
              Coming Soon to the App Store
            </a>
          </div>
        </div>

        {/* Right: iPad Mockup */}
        <div className="flex justify-center lg:justify-end">
          <div className="relative w-[380px] h-[520px] bg-white rounded-[2rem] shadow-2xl border-[8px] border-gray-800 p-6 flex flex-col items-center justify-center">
            <div className="w-16 h-16 rounded-full bg-ha-coral mb-6" />
            <h2 className="text-3xl font-bold text-black">Hair Agent</h2>
            <p className="text-gray-500 mt-2 text-center">
              Your personal hair care advisor
            </p>
            <div className="mt-8 w-full bg-ha-coral text-white text-center py-3 rounded-full font-semibold">
              Get Started
            </div>
            <div className="flex gap-2 mt-6">
              <div className="w-3 h-3 rounded-full bg-ha-pink" />
              <div className="w-3 h-3 rounded-full bg-ha-blue" />
              <div className="w-3 h-3 rounded-full bg-ha-yellow" />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
