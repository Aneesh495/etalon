"""
topology.py: Optical Graph Topology and Spectrum State Representation.

Models ROADM mesh nodes, multi-degree fiber spans, SRLGs, and 6.25 GHz / 12.5 GHz flexible grid slots.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple

@dataclass
class OpticalNode:
    node_id: int
    name: str
    degree: int = 4
    add_drop_ports: int = 96
    colorless: bool = True
    directionless: bool = True
    contentionless: bool = True

@dataclass
class OpticalFiberLink:
    link_id: int
    src_node: int
    dst_node: int
    distance_km: float
    loss_db_per_km: float = 0.20
    dispersion_ps_nm_km: float = 16.5
    srlgs: List[int] = field(default_factory=list)
    spectrum_slots: List[bool] = field(default_factory=lambda: [False] * 768) # 768 x 6.25 GHz slices

    @property
    def free_slots_count(self) -> int:
        return sum(1 for s in self.spectrum_slots if not s)

    @property
    def utilization_percent(self) -> float:
        occupied = sum(1 for s in self.spectrum_slots if s)
        return (occupied / len(self.spectrum_slots)) * 100.0

@dataclass
class OpticalTopology:
    name: str
    nodes: Dict[int, OpticalNode] = field(default_factory=dict)
    links: Dict[int, OpticalFiberLink] = field(default_factory=dict)
    adjacency: Dict[int, List[int]] = field(default_factory=dict)

    def add_node(self, node: OpticalNode) -> None:
        self.nodes[node.node_id] = node
        if node.node_id not in self.adjacency:
            self.adjacency[node.node_id] = []

    def add_link(self, link: OpticalFiberLink) -> None:
        self.links[link.link_id] = link
        self.adjacency[link.src_node].append(link.link_id)

    @property
    def node_count(self) -> int:
        return len(self.nodes)

    @property
    def link_count(self) -> int:
        return len(self.links)

    @property
    def total_fiber_km(self) -> float:
        return sum(l.distance_km for l in self.links.values())

    @property
    def average_degree(self) -> float:
        if not self.nodes:
            return 0.0
        return (2.0 * self.link_count) / self.node_count

def load_standard_topology(name: str) -> OpticalTopology:
    """Loads standardized reference optical network topologies."""
    norm_name = name.lower().replace("-", "").replace("_", "")

    if "usnet" in norm_name:
        topo = OpticalTopology(name="US-Net 24-Node Carrier Backbone")
        for i in range(1, 25):
            topo.add_node(OpticalNode(node_id=i, name=f"US-Node-{i}"))
        # Add primary mesh links
        links = [
            (1, 1, 2, 850.0), (2, 2, 3, 620.0), (3, 3, 4, 450.0), (4, 4, 5, 780.0),
            (5, 5, 6, 920.0), (6, 6, 7, 540.0), (7, 7, 8, 1100.0), (8, 8, 9, 680.0),
            (9, 9, 10, 830.0), (10, 10, 11, 490.0), (11, 11, 12, 750.0), (12, 12, 13, 600.0),
            (13, 13, 14, 410.0), (14, 14, 15, 950.0), (15, 15, 16, 720.0), (16, 16, 17, 530.0),
            (17, 17, 18, 640.0), (18, 18, 19, 810.0), (19, 19, 20, 480.0), (20, 20, 21, 670.0),
            (21, 21, 22, 590.0), (22, 22, 23, 760.0), (23, 23, 24, 820.0), (24, 24, 1, 910.0),
            (25, 1, 12, 2100.0), (26, 3, 15, 1850.0), (27, 5, 18, 1750.0), (28, 7, 21, 1900.0),
        ]
        for l_id, u, v, dist in links:
            topo.add_link(OpticalFiberLink(link_id=l_id, src_node=u, dst_node=v, distance_km=dist, srlgs=[1000 + l_id]))
        return topo

    elif "tokyo" in norm_name:
        topo = OpticalTopology(name="Tokyo Metro 16-Node Meshed Ring")
        for i in range(1, 17):
            topo.add_node(OpticalNode(node_id=i, name=f"Tokyo-Node-{i}"))
        for i in range(1, 17):
            nxt = (i % 16) + 1
            topo.add_link(OpticalFiberLink(link_id=i, src_node=i, dst_node=nxt, distance_km=15.0, srlgs=[5000 + i]))
            chord_dst = ((i * 3) % 16) + 1
            topo.add_link(OpticalFiberLink(link_id=16 + i, src_node=i, dst_node=chord_dst, distance_km=28.0, srlgs=[5050 + i]))
        return topo

    else: # Default 6-node core mesh
        topo = OpticalTopology(name="Generic 6-Node Core Mesh")
        for i in range(1, 7):
            topo.add_node(OpticalNode(node_id=i, name=f"Core-{i}"))
        links = [(1, 1, 2, 120.0), (2, 2, 3, 140.0), (3, 3, 4, 110.0), (4, 4, 5, 130.0), (5, 5, 6, 115.0), (6, 6, 1, 125.0), (7, 1, 4, 250.0), (8, 2, 5, 230.0)]
        for l_id, u, v, dist in links:
            topo.add_link(OpticalFiberLink(link_id=l_id, src_node=u, dst_node=v, distance_km=dist, srlgs=[l_id]))
        return topo
