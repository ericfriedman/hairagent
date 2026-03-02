export function Footer() {
  return (
    <>
      {/* Final CTA */}
      <section className="py-24 px-6 bg-white text-center">
        <h2 className="text-4xl md:text-5xl font-bold text-black mb-6">
          Ready to Meet Your Hair BFF?
        </h2>
        <p className="text-xl text-black/60 mb-10">
          Download Hair Agent and start your personalized hair care journey.
        </p>
        <a
          href="#"
          className="inline-block bg-black text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-black/80 transition-colors"
        >
          Coming Soon to the App Store
        </a>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 bg-gray-100 text-center">
        <p className="text-sm text-black/40">
          &copy; {new Date().getFullYear()} Hair Agent. Made with love by a
          father-daughter team.
        </p>
      </footer>
    </>
  );
}
