export function Sparkle({ className = "w-8 h-8", color = "currentColor" }: { className?: string; color?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Main 4-point star */}
      <path
        d="M12 2L13.5 9.5L20 12L13.5 14.5L12 22L10.5 14.5L4 12L10.5 9.5L12 2Z"
        fill={color}
        opacity="0.9"
      />
      {/* Small accent star */}
      <path
        d="M19 3L19.5 5.5L22 6L19.5 6.5L19 9L18.5 6.5L16 6L18.5 5.5L19 3Z"
        fill={color}
        opacity="0.6"
      />
      {/* Tiny accent star */}
      <path
        d="M5 17L5.3 18.3L6.5 18.5L5.3 18.8L5 20L4.7 18.8L3.5 18.5L4.7 18.3L5 17Z"
        fill={color}
        opacity="0.4"
      />
    </svg>
  );
}
