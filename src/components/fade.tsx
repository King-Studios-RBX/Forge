import Vide, { Derivable, read, source } from "@rbxts/vide";

type FadeProps = {
	name?: string;
	groupColor?: Derivable<Color3>;
	groupTransparency?: Derivable<number>;
	visible?: Derivable<boolean>;
	anchor?: Derivable<Vector2>;
	position?: Derivable<UDim2>;
	size?: Derivable<UDim2>;
	rotation?: Derivable<number>;
	zIndex?: Derivable<number>;
	layoutOrder?: Derivable<number>;
	events?: Vide.InstanceEventAttributes<Frame>;
	before?: () => Vide.Node;
	children?: Vide.Node;
	parent?: Instance;
};

export default function FadeComponent(props: FadeProps) {
	const frameRef = source<Frame>();
	const canvasGroupRef = source<CanvasGroup>();

	const transitioning = () => {
		const color = read(props.groupColor) || new Color3(1, 1, 1);
		const transparency = read(props.groupTransparency) ?? 0;

		return transparency > 0.01 || color !== new Color3(1, 1, 1);
	};

	<frame
		BackgroundTransparency={1}
		Size={new UDim2(1, 0, 1, 0)}
		Parent={() => (transitioning() ? canvasGroupRef() : frameRef())}
	>
		{props.children}
	</frame>;

	return (
		<frame
			Name={props.name ?? "Transition"}
			BackgroundTransparency={1}
			AnchorPoint={props.anchor}
			Size={props.size || new UDim2(1, 0, 1, 0)}
			Position={props.position}
			Rotation={props.rotation}
			LayoutOrder={props.layoutOrder}
			ZIndex={props.zIndex}
			Parent={props.parent}
			{...props.events}
		>
			<canvasgroup
				action={canvasGroupRef}
				GroupTransparency={props.groupTransparency}
				GroupColor3={props.groupColor}
				BackgroundTransparency={1}
				Size={new UDim2(1, 0, 1, 0)}
			>
				{props.before?.()}
			</canvasgroup>

			<frame
				action={frameRef}
				ClipsDescendants
				BackgroundTransparency={1}
				Size={new UDim2(1, 0, 1, 0)}
			>
				{props.before?.()}
			</frame>
		</frame>
	);
}
