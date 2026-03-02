import { Sparkle } from "./sparkle";

export function About() {
  return (
    <section className="py-24 px-6 bg-ha-yellow/30 relative overflow-hidden">
      {/* Decorative blobs */}
      <div className="absolute top-0 right-0 w-64 h-64 bg-ha-pink/20 rounded-full blur-3xl" />
      <div className="absolute bottom-0 left-0 w-48 h-48 bg-ha-blue/20 rounded-full blur-3xl" />

      <div className="relative z-10 mx-auto max-w-3xl text-center">
        <Sparkle className="w-10 h-10 mx-auto mb-6" color="#d4c46e" />
        <h2 className="text-4xl md:text-5xl font-bold text-black mb-8">
          Built by a Kid Who Knows Hair
        </h2>
        <p className="text-xl text-black/60 leading-relaxed">
          Hair Agent was dreamed up by an 11-year-old who believed everyone
          deserves great hair care - not just people who can afford expensive
          salon products. Together with her dad, she built an app that gives
          you personalized, all-natural hair tips using ingredients you
          already have at home. Real advice, from a real kid, for real hair.
        </p>
      </div>
    </section>
  );
}
