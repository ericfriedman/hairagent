import { Sparkle } from "./sparkle";

const features = [
  {
    title: "All-Natural Ingredients",
    description: "Honey, coconut oil, aloe vera — stuff from your kitchen.",
    bgColor: "bg-ha-pink",
    sparkleColor: "#e8899a",
  },
  {
    title: "Personalized to You",
    description: "Not generic advice. Matched to YOUR hair type and goals.",
    bgColor: "bg-ha-blue",
    sparkleColor: "#89b8d4",
  },
  {
    title: "No Salon Needed",
    description: "Professional-quality care, DIY style.",
    bgColor: "bg-ha-coral",
    sparkleColor: "#e87a70",
  },
  {
    title: "Fun for Everyone",
    description: "Whether you're 10 or 45, great hair has no age limit.",
    bgColor: "bg-ha-yellow",
    sparkleColor: "#d4c46e",
  },
];

export function Features() {
  return (
    <section className="py-24 px-6 bg-white">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          What Makes It Different
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {features.map((feature) => (
            <div
              key={feature.title}
              className="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden"
            >
              {/* Colored top panel with sparkle - matching app card style */}
              <div
                className={`${feature.bgColor} h-32 flex items-center justify-center relative`}
              >
                <Sparkle className="w-10 h-10" color={feature.sparkleColor} />
              </div>
              <div className="p-6">
                <h3 className="text-xl font-bold text-black mb-2">
                  {feature.title}
                </h3>
                <p className="text-base text-black/50">
                  {feature.description}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
