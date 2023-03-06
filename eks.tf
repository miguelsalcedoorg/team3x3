resource "aws_eks_cluster" "eks-cluster" {
  name     = "Team3-eks-cluster"
  role_arn = aws_iam_role.EKSClusterRole.arn
  vpc_config {
    subnet_ids         = aws_subnet.public[*].id
    # security_group_ids = [aws_security_group.SG_LB.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
  }
resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "t3_medium-node_group"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = aws_subnet.public[*].id


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }


  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"
  disk_size      = 20


  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy

  ]
}
