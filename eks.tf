resource "aws_eks_cluster" "eks-cluster" {
  name     = "Team3-EKS-cluster"
  role_arn = aws_iam_role.Team3EKSClusterRole.arn
  vpc_config {
    subnet_ids         = aws_subnet.public[*].id
    # security_group_ids = [aws_security_group.SG_LB.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.Team3AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.Team3AmazonEKSVPCResourceController,
  ]
  }
resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "t3_medium-node_group"
  node_role_arn   = aws_iam_role.Team3NodeGroupRole.arn
  subnet_ids      = aws_subnet.public[*].id


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }
  depends_on = [
    aws_iam_role_policy_attachment.Team3AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Team3AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.Team3AmazonEKS_CNI_Policy

  ]
}
