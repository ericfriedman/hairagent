export function Footer() {
  return (
    <>
      {/* Final CTA */}
      <section className="py-24 px-6 bg-white text-center relative overflow-hidden">
        {/* Decorative blobs */}
        <div className="absolute top-1/2 left-0 w-72 h-72 bg-ha-pink/20 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2" />
        <div className="absolute top-1/2 right-0 w-72 h-72 bg-ha-blue/20 rounded-full blur-3xl translate-x-1/2 -translate-y-1/2" />

        <div className="relative z-10">
          {/* Progress bar like the app */}
          <div className="flex gap-2 justify-center mb-12">
            <div className="w-20 h-1.5 rounded-full bg-ha-pink" />
            <div className="w-20 h-1.5 rounded-full bg-ha-blue" />
            <div className="w-20 h-1.5 rounded-full bg-ha-coral" />
          </div>

          <h2 className="text-4xl md:text-5xl font-bold text-black mb-6">
            Ready to Meet Your Hair BFF?
          </h2>
          <p className="text-xl text-black/50 mb-10 max-w-lg mx-auto">
            Download Hair Agent and start your personalized hair care journey.
          </p>
          <a
            href="#"
            className="inline-block bg-ha-coral text-white px-10 py-4 rounded-full text-lg font-semibold hover:opacity-90 transition-opacity shadow-lg shadow-ha-coral/30"
          >
            Coming Soon to the App Store
          </a>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 bg-gray-50 text-center">
        <div className="flex gap-2 justify-center mb-3">
          <div className="w-2.5 h-2.5 rounded-full bg-ha-pink" />
          <div className="w-2.5 h-2.5 rounded-full bg-ha-blue" />
          <div className="w-2.5 h-2.5 rounded-full bg-ha-yellow" />
          <div className="w-2.5 h-2.5 rounded-full bg-ha-coral" />
        </div>
        <p className="text-sm text-black/40">
          &copy; {new Date().getFullYear()} Hair Agent. Made with love by a
          father-daughter team.
        </p>
      </footer>
    </>
  );
}
